Return-Path: <linux-kernel-owner+w=401wt.eu-S1764312AbXHDASb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764312AbXHDASb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 20:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762709AbXHDASW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 20:18:22 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:14214 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762625AbXHDASW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 20:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b+SI6j6232jXsvVHGScMQP5anePSDU61pih6jQCXMisAxG1ItnGRq/PYwIqkYqhnHq4JZGNnhhbWPJyjUawpBiGxBKZNQ2+CwholHQWM5DCeFPnmO5CGZBSUxYE1ikWpb39nJatvHRBUGgP0Nm94rjFn+vOKshhdYKUNjFbE6W4=
Message-ID: <9a8748490708031718q677dcc92l84245176eeb99f24@mail.gmail.com>
Date: Sat, 4 Aug 2007 02:18:21 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Gert Robben" <lkml@gert.robben.nu>
Subject: Re: PROBLEM: snd-au8830: dead after software suspend
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46B3C44D.7020801@gert.robben.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A4F5.2000708@gert.robben.nu> <46B3C44D.7020801@gert.robben.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/07, Gert Robben <lkml@gert.robben.nu> wrote:
> Robert Hancock wrote:
> > Have you reported this to the ALSA people?
> No, I thought this might as well be something for PCI or PM people, and
> I expected some ALSA people are also reading this list.
> If not, where else should I report this exactly?
>

alsa-devel would seem to be a good starting point - see
http://www.alsa-project.org/mailing-lists.php
Also, the author of the driver, Manuel Jander <mjander@embedded.cl>,
would probably be a good person to add to Cc.
And keeping LKML on Cc while sending to above people usually never hurts :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
