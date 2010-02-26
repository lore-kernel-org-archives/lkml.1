Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935402Ab0BZHPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:15:41 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:45460 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935359Ab0BZHPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:15:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KDgLE6M1wSHg7bUtvej4lbCxCovImExyhNTg0uDsro9/5Kfjoewu2Xqhba3EsxVRby
         3JDgD1ZGvWKxZh2CKlAdOUwsz1n7eNfjunK7Jux5vx9hvoL3qeLyKza6ySVTsbWQOf3Y
         DR7lod252r7WKP0wIIDvfpOM7qljlVSgw549c=
MIME-Version: 1.0
In-Reply-To: <a8e1da1002251714l55ccbd44ibc1119770667c62b@mail.gmail.com>
References: <20100225155359.GA2722@darkstar> <20100225185515.GB3305@core2>
	 <a8e1da1002251714l55ccbd44ibc1119770667c62b@mail.gmail.com>
Date: Fri, 26 Feb 2010 09:15:39 +0200
Message-ID: <b6fcc0a1002252315k1fd5360ehf5ea33566c19515d@mail.gmail.com>
Subject: Re: [PATCH 03/07] kernel.h string cleanup
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 3:14 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Yeah, same question, then where should they go?

Should I hand a patch to you, so you can repost it?

> I think string.h is fine.

It obviously isn't fine.

Why all of sudden kernel.h split when kernel.h is for simple misc stuff
for which there is no other place.
