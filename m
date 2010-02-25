Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab0BYJra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 04:47:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab0BYJr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 04:47:28 -0500
Date: Thu, 25 Feb 2010 10:42:41 +0100
From: Jerome Glisse <jglisse@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] git ignore *.builtin generated file
Message-ID: <20100225094241.GM11509@localhost.localdomain>
References: <1266582790-11506-1-git-send-email-jglisse@redhat.com>
 <2375c9f91002191831y10918541mb5e2463d97c8f3ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f91002191831y10918541mb5e2463d97c8f3ae@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 10:31:18AM +0800, Américo Wang wrote:
> On Fri, Feb 19, 2010 at 8:33 PM, Jerome Glisse <jglisse@redhat.com> wrote:
> > This patch makes git ignore any *.builtin file (best patch of the year)
> >
> > Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> 
> 
> Sorry, besides "modules.builtin", what other builtin files did you see?
> We already exclude "modules.builtin".
> 

Sorry my tree didn't have the updated .gitignore dunno why maybe a conflict
in one of my merge.

Cheers,
Jerome
