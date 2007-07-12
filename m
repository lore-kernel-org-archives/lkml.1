Return-Path: <linux-kernel-owner+w=401wt.eu-S933155AbXGLMfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155AbXGLMfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758799AbXGLMf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:35:26 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:32076 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640AbXGLMfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LjgQZgviUGs5Q1dNZuKBL2pzo1uO9IkodqQW4pjMQItzpbtFgArl+68ngGwBbp8iCm7GcPd7w2cKZXrUDlVXtyiNeDbkl+YhWCEn/BPYwJRlg1TouCwFo5ZvHqVyKqRwUCgFo/VoETSMwhGRT0TZflLFmegAkJp+iLtvoYuIvb8=
Message-ID: <3aa654a40707120535g7d1b73uf5c73ef68a1cd98a@mail.gmail.com>
Date: Thu, 12 Jul 2007 05:35:24 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Kacper Wysocki" <kacperw@online.no>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matthew Hawkins" <darthmdh@gmail.com>, linux-kernel@vger.kernel.org,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       linux-mm@kvack.org, "Paul Jackson" <pj@sgi.com>
In-Reply-To: <367a23780707120506o423f6352h5edeca8535135068@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <200707102015.44004.kernel@kolivas.org>
	 <b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>
	 <20070710181419.6d1b2f7e.akpm@linux-foundation.org>
	 <367a23780707120506o423f6352h5edeca8535135068@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/07, Kacper Wysocki <kacperw@online.no> wrote:
> performance, testing and impact. The big question is: why *don't* we
> merge it?

Stranger thing to me is that this is like Déjà Vu. Many have asked
this same question. When users were asked for their comment before
many end users and some developers have given rave reviews. I don't
remember anyone giving it the heavy thumbs-down, with exception of
when things needed fixing (over 6 months ago?). It continues to go
unmerged. Is there a clear answer on what needs to happen for it to
get merged?
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
