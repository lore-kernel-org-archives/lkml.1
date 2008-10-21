Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYJUMJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYJUMJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYJUMJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:09:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:23239 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYJUMJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=dp6v3d/kbcrYxaG+hBq5301LqaPYYPDklOC0U4ZKPEiFx6XM4qadbF4mWp/pFRFlPC
         N/QZpSuhrHi0W+gXXS40RG5TDxwbALfjUrH2lIF8sqJMVFjCghDrpK24V0mwArBV6tiq
         OfGznndg/JurLN/3aGxOAY/OyT8+p4/h5TXV0=
Date: Tue, 21 Oct 2008 08:07:35 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21
Message-ID: <20081021120735.GA10567@yoda.jdub.homelinux.org>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021195109.ed83b102.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 07:51:09PM +1100, Stephen Rothwell wrote:
>I have also applied the following patches for known problems:
>
>	sparc: qlogicpti fallout from sbus removal
>	ibm_newemac: Fix new MAL feature handling

Did you?  I put that in my next branch, which Ben pulled into his powerpc
tree, so it shouldn't have needed applying separately.

josh
