Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXGQPE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXGQPE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXGQPEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:04:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:32858 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbXGQPEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sbPX8fZWipxlnAh8sUA9JPvN27X9nKZpsPfwyFnUyZ+pQ8rqqN7YEYcWZt87PMK9n4hnbEwe6HeyHcwBC58/VbkVO7B53KLnamiB2IVxR9jZCijOhhoROKdomiXl14z/FDpZ2W0ys5iDZ1jWbEIijD3MthKBBRTxOagj5gdtFWw=
Message-ID: <dcf706c60707170804p3fecc7c9q26ddec60fd9e59b3@mail.gmail.com>
Date: Tue, 17 Jul 2007 17:04:47 +0200
From: "Sasa Ostrouska" <casaxa@gmail.com>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Subject: Re: VESAFB CUSTOM RESOLUTION
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <469CD54A.4040003@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
	 <469CD54A.4040003@mandic.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Renato S. Yamane <renatoyamane@mandic.com.br> wrote:
> Sasa Ostrouska escreveu:
> > I want to ask one question about a custom resolution in the console.
> > I have a Sony Vaio Laptop VGN-SZ2VP/X, the screen resolution is
> > 1280x800, now I'm using the vga=773 which is an 1024x768 but this is
> > ugly as I get a border of about 2-3cm on one the sides of the screen.
> > So is there a way that I set the 1280x800 resolution at boot time ?
>
> Use vga=866 to set 1280x800 in boot time.
> In Documentation/fb/vesafb.txt is commented only 1280x1024, but in same
> man page is commented that you can read /Documentation/svga.txt and in
> this document you can find this:
>
> ** Short intro for the impatient: Just use vga=ask for the first time,
> ** enter `scan' on the video mode prompt, pick the mode you want to use,
> ** remember its mode ID (the four-digit hexadecimal number) and then
> ** set the vga parameter to this number (converted to decimal first).
>
> Regards,
> Renato S. Yamane
>

Many many thanks for your quick answers, I will try those solutions.

Rgds
Sasa
