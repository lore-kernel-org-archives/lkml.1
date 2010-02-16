Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab0BPMX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:23:57 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:57588 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab0BPMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:23:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pLzlCx0cMObzJHpRBCNFbvg7saQL37oo/iE4OGWeKePhpI6/gJsuqZtEHEv1nAAqyZ
         2+JD2M+EOnBrn3YQioQUwJ9FBGsA2DY7pDeUC0NKwDkxGWijVlQCNzXhHzjcMsk1faAa
         MCemA3Ipcjjji3lAfep1sI9enmAKz5mHcwkE0=
MIME-Version: 1.0
In-Reply-To: <201002161520.26700@zigzag.lvk.cs.msu.su>
References: <201002161520.26700@zigzag.lvk.cs.msu.su>
Date: Tue, 16 Feb 2010 14:23:55 +0200
Message-ID: <b6fcc0a1002160423o1269996bw34c033015b1ab500@mail.gmail.com>
Subject: Re: Extended error reporting to user space?
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 2:20 PM, Nikita V. Youshchenko <yoush@cs.msu.su> wrote:
> Unfortunately this -EINVAL is not really useful.

There is no such thing.
Driver can spit messages with printk() though.
