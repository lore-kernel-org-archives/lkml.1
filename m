Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbXIJOMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbXIJOMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbXIJOLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:11:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759105AbXIJOLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:11:53 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: PPC64 AT_IGNOREPPC question
References: <m3odgehs9e.fsf@dhcp-lab-156.englab.brq.redhat.com>
	<18148.13191.876031.378696@cargo.ozlabs.ibm.com>
From: Vitaly Mayatskikh <vmayatsk@redhat.com>
X-URL: http://people.redhat.com/vmayatsk
Date: Mon, 10 Sep 2007 08:55:31 +0200
In-Reply-To: <18148.13191.876031.378696@cargo.ozlabs.ibm.com> (Paul Mackerras's message of "Mon\, 10 Sep 2007 03\:55\:19 +1000")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Message-ID: <m3y7fezk2h.fsf@dhcp-lab-143.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> writes:

> I'll have to check when that change was done and decide whether we can
> now take out the AT_IGNOREPPC entries.  If not it sounds like we need
> to expand AT_VECTOR_SIZE.

I've looked over glibc-2.3 sources (is it old enough? :) and didn't
notice any specialities for AT_IGNOREPPC.

-- 
Vitaly Mayatskikh <vmayatsk@redhat.com>

Kernel development
Red Hat Czech, Brno

Phone: +420 532 294 111
IRC: vitaly on #kernel, #brno
GPG: 0x4BA2E8FB
