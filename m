Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbXEDNxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbXEDNxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbXEDNxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:53:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:24024 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbXEDNxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DU9pu1s+K9PA+EYsDiv29xSbhXlpaHlFZkYGg/0JI9s05pXuCmBoUxLAUDYq0YTPH6nweFt4bHc2rqvdeLUvxAMci2J5pl0TpxWVcQNoeSzXjjODYdb5o54n8KRa3ZDB6uuD5Aqyc2RoEKvTIols32lM+g3bUusTUfeBS/05pz0=
Message-ID: <99e4df080705040653l38daa61aw3883b7c55c8e9de7@mail.gmail.com>
Date: Fri, 4 May 2007 21:53:34 +0800
From: "la deng" <ladeng.mimi@gmail.com>
To: "WANG Cong" <xiyou.wangcong@gmail.com>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "la deng" <ladeng.mimi@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: c 's OOP in VFS vs c++'s OOP
In-Reply-To: <20070504123047.GA2255@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <99e4df080705040132m41116db3y50c73c79528d6206@mail.gmail.com>
	 <20070504101129.GA5482@localhost.localdomain>
	 <99e4df080705040400p66819117sec7f7d88d3794871@mail.gmail.com>
	 <Pine.LNX.4.61.0705041339220.18504@yvahk01.tjqt.qr>
	 <20070504123047.GA2255@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, WANG Cong <xiyou.wangcong@gmail.com> wrote:
> On Fri, May 04, 2007 at 01:40:04PM +0200, Jan Engelhardt wrote:
> >
> >On May 4 2007 19:00, la deng wrote:
> >>
> >>
>
> C gives you the power to control nearly everything. You can, of course, control the registers via inserting assembly code. That's not the fault of C.
I think you don't understand me correctly

I know c can inline assmebly to control registers

but,this control not the globe Analysis of control register like
internal of c++ compiler or lisp 's compiler language,c can't

sigh
