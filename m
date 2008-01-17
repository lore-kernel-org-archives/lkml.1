Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYAQTp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYAQTp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbYAQTo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:44:56 -0500
Received: from mail.suse.de ([195.135.220.2]:40311 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbYAQToz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:44:55 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Print which shared library/executable faulted in segfault etc. messages v3
Date: Thu, 17 Jan 2008 20:44:46 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
References: <20080116231534.GA25995@wotan.suse.de> <Pine.LNX.4.64.0801171948280.9008@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801171948280.9008@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801172044.46434.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >hal-resmgr[13791]: segfault at 3c rip 2b9c8caec182 rsp 7fff1e825d30
> >error 4 in libacl.so.1.1.0[2b9c8caea000+6000]
> 
> Can this also be done for executables?

This is done for executables.

-Andi
