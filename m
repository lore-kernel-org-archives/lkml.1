Return-Path: <linux-kernel-owner+w=401wt.eu-S938319AbXHIHHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938319AbXHIHHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764456AbXHIHHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:07:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:64265 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976AbXHIHHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hKkj8J9u0qOnJuRjMdEUSeVBtk5xrTvo8pv3gT9EgDBAIXTwHxnMjczenQw5PNpesZvlQeKYRxR6C35ibXK3puG3O2V2iW/AR1g1urqnmVGre6Ek/occvDkTVeLD1TDuhrlsdrIYA/jTEx21vblSTtBR6RNgedyzlLSHkm9PZc4=
Message-ID: <5d6222a80708090007h3d185ecdm3ea8fa0b5ee96050@mail.gmail.com>
Date: Thu, 9 Aug 2007 04:07:32 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <46BABC0F.5070002@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <11865468321629-git-send-email-gcosta@redhat.com>
	 <11865468362401-git-send-email-gcosta@redhat.com>
	 <11865468394005-git-send-email-gcosta@redhat.com>
	 <11865468431616-git-send-email-gcosta@redhat.com>
	 <1186546847263-git-send-email-gcosta@redhat.com>
	 <11865468513077-git-send-email-gcosta@redhat.com>
	 <46BAB5C8.5090906@goop.org>
	 <5d6222a80708090002y7fdc6f2dw1dbacd3d27a86433@mail.gmail.com>
	 <46BABC0F.5070002@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> > Does it really matter?
> >
>
> Well, yes, if alignment is an issue.
Of course, But the question rises from the context that they are both
together at the beginning. So they are not making anybody non-aligned.
Then the question: Why would putting it in the end be different to
putting them _together_, aligned at the beginning ?

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
