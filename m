Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbYGHAyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbYGHAyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 20:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbYGHAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 20:54:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:33414 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbYGHAyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 20:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Qknu1q4VzmZTcl3ufjoCMI9R5qAPo85pwGDVeNZgkfsskqrBMl2/LjQ2NRwLTnLCIY
         pkM/0CdZS1Sjv7vedxfe+lkAEeP1/26Hm+q+QHY2PhZKMCcl4LNwQ9M8rIZ/GtEwIenR
         BHmrOZGzF1ODTkvvsBa6xVZDZ9GEl++Ao6x88=
Message-ID: <45a44e480807071754j3f6c06cfh539611b54fab8fde@mail.gmail.com>
Date: Mon, 7 Jul 2008 20:54:35 -0400
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Markus Armbruster" <armbru@redhat.com>
Subject: Re: "fb-defio: fix page list with concurrent processes"
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m3bq19e881.fsf@crossbow.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4856E38E.1040203@goop.org>
	 <45a44e480806161811k423fecf2r2d79609a5c0d057@mail.gmail.com>
	 <m3mykyr7wf.fsf@crossbow.pond.sub.org>
	 <45a44e480807031644vb5dcc31sf9558bffd772c8b9@mail.gmail.com>
	 <m3bq19e881.fsf@crossbow.pond.sub.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 4:43 PM, Markus Armbruster <armbru@redhat.com> wrote:
> Unfortunately, I missed that assumption of yours %-}
>
> Still want me to post it for you?
>

No worries, will post shortly. Sorry for the confusion.

Thanks,
jaya
