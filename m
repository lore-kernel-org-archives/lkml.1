Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbYA2Hf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbYA2Hf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 02:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYA2HfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 02:35:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39998 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYA2HfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 02:35:16 -0500
Date: Tue, 29 Jan 2008 09:09:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Joachim Deguara <joachim.deguara@amd.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Dean Roe <roe@cray.com>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c II
Message-ID: <20080129080927.GA1414@one.firstfloor.org>
References: <200801281211.28214.joachim.deguara@amd.com> <p73y7a970nd.fsf@bingen.suse.de> <200801282012.47190.yinghai.lu@sun.com> <20080129045659.GA31847@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129045659.GA31847@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> SRAT is essentially just a two dimensional table with node distances.

Sorry, that was actually SLIT. SRAT is not two dimensional, but also
relatively simple. SLIT you don't really need to implement.

-Andi
