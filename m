Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbYGCXou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbYGCXou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbYGCXom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:44:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:36309 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYGCXol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ee36K5BW1xxqOBc1YtE+Iiye6HHZ9fku2bEn0x0AX55JkAzS+ABw90LOoSVr3IiQOx
         FWHvXs9HPTrWzEjE0BcMCCHxgZJ3eszFO3UH/guR5eKsskslWV9V5K4Iu0PK0BYxC+o7
         KUepiiz9MFMlKV5pMiIpy3kKnuWljCOlgrfEA=
Message-ID: <45a44e480807031644vb5dcc31sf9558bffd772c8b9@mail.gmail.com>
Date: Fri, 4 Jul 2008 07:44:38 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Markus Armbruster" <armbru@redhat.com>
Subject: Re: "fb-defio: fix page list with concurrent processes"
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m3mykyr7wf.fsf@crossbow.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4856E38E.1040203@goop.org>
	 <45a44e480806161811k423fecf2r2d79609a5c0d057@mail.gmail.com>
	 <m3mykyr7wf.fsf@crossbow.pond.sub.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2008 at 5:10 AM, Markus Armbruster <armbru@redhat.com> wrote:
>
> Jaya, any news?
>

Hi Markus,

In the thread, as per your point:

> better, somewhat slow code, or somewhat useless code?  I'd like to see
> the fix merged as soon as possible.  You can always improve its
> performance later.

I responded:

> Yup, I've got no problem if the old patch is requeued and merged.

I'd assumed that you would requeue that patch.

Thanks,
jaya
