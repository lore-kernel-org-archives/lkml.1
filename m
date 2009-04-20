Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZDTTYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZDTTYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZDTTYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:24:12 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:46225 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbZDTTYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:24:10 -0400
X-Greylist: delayed 881 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 15:24:10 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=apqCEsrO/blrbRmX2fMpSv548nnG+tJRhGCDcrL4XcFTlj7EXEOuQ7dUDfnxwodzv9ssPCJq410cwUu1beDqUJddSp0eMCCqUDWrZrt/uNkCX+4d3DS89gaQEQBG4lYg;
Message-ID: <49ECC866.2070602@simon.arlott.org.uk>
Date: Mon, 20 Apr 2009 20:09:26 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090328)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: USB: usb-serial ch341: support for DTR/RTS/CTS
References: <200903261928.n2QJSVrp006739@hera.kernel.org> <20090326193825.4fddfa3c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090326193825.4fddfa3c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/09 19:38, Alan Cox wrote:
> On Thu, 26 Mar 2009 19:28:31 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
>> Gitweb:     http://git.kernel.org/linus/664d5df92e88b6ef091048a802b3750f4e989180
>> Commit:     664d5df92e88b6ef091048a802b3750f4e989180
>> Parent:     bcbbbfc169e837f0bf54dd4a6ef0a6494fb14925
>> Author:     Werner Cornelius <werner@cornelius-consult.de>
>> AuthorDate: Fri Jan 16 21:02:41 2009 +0100
>> Committer:  Greg Kroah-Hartman <gregkh@suse.de>
>> CommitDate: Tue Mar 24 16:20:28 2009 -0700
> 
> I see no signoffs from the original author of this patch pre-update
> (and my attempts to get one were not replied to). Thus I never merged it
> - has this changed ?

There is a Signed-off-by: hiding at the very end of http://lkml.org/lkml/2007/9/21/93

-- 
Simon Arlott
