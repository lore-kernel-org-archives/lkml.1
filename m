Return-Path: <linux-kernel-owner+w=401wt.eu-S1751767AbZJPE2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbZJPE2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 00:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZJPE2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 00:28:16 -0400
Received: from aglcosbs02.cos.agilent.com ([192.25.218.39]:59809 "EHLO
	aglcosbs02.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbZJPE2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 00:28:16 -0400
Message-ID: <4AD7F633.4070507@agilent.com>
Date: Thu, 15 Oct 2009 21:27:31 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: fs/pipe.c null pointer dereference
References: <4AD5D476.6010103@agilent.com> <200910141653.03611.elendil@planet.nl> <4AD655C0.2030202@agilent.com> <200910150211.43532.elendil@planet.nl>
In-Reply-To: <200910150211.43532.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 04:27:34.0124 (UTC) FILETIME=[FBA02AC0:01CA4E18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Good luck with the hunt.

I've logged a defect:

http://bugzilla.kernel.org/show_bug.cgi?id=14416

which includes a proposed fix and script to reproduce.

Earl



