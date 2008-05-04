Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYEDQM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYEDQM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYEDQMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:12:51 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:39813 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbYEDQMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qe3UZbdm0beXeTm1ZfBS+dHhOW6Bw49U7MNJrhJisuduwJziF0W2gGPAJxlBlalWIB2IYc+WnmODUUDWdgPUcruM+szJObP7hxqLqFvWzQnIbnboWaqmhZXcxCEWrX7qyZMjXpcx6HXXfR4Aa+RoOnx4oxb41/HA85Tj+lpKYE8=
Message-ID: <dd18b0c30805040912l2d12115bi3987d8a5ed0372bf@mail.gmail.com>
Date: Sun, 4 May 2008 16:12:49 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: nopage mm.h
Cc: npiggin@suse.de,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <481D68E0.1040608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com>
	 <481D68E0.1040608@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 7:42 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Justin Mattock napsal(a):
>
> > Hello; I have a question about the nopage function that was removed in
> > the kernel.
> > What would be the best way for me to build a module that has a nopage
> > funtion in it?
> >
>
>  use .fault instead
>
Hello thanks for the response, I'll have a look into that. The problem
I'm confronted with right now is the module is not going to
install due to it being a non-GPL module. After doing some reading I
was unawre that the kernel was going GPL-only in 2008, so with that in
mind I need to comply with the regulations. So the question I have now
is: Is there a module that is GPL approved that will give me 3D for
the macbook pro. And also recover from suspend?
regards;

-- 
Justin P. Mattock
