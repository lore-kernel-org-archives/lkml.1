Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbYC2M54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbYC2M54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 08:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYC2M5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 08:57:49 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:35060 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751050AbYC2M5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 08:57:49 -0400
Message-ID: <47EE3CCD.7040501@davidnewall.com>
Date: Sat, 29 Mar 2008 23:27:49 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ketil Froyn <ketil@froyn.name>
CC: "" <jamagallon@ono.com>, linux-kernel@vger.kernel.org
Subject: Re: unexpected rename() behaviour
References: <47ED8858.9000401@froyn.name> <20080329011656.7c38265a@werewolf> <47EE2072.7000504@froyn.name>
In-Reply-To: <47EE2072.7000504@froyn.name>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ketil Froyn wrote:
> Is this a corner case undefined by POSIX, for instance, or does POSIX
> explicitly say that this is the correct behaviour? 

The answers to these questions are no and yes.  See "System Interfaces"
in "The Open Group Base Specifications Issue 6."  Perhaps you could have
discovered this for yourself?
