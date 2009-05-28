Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbZE1Hcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbZE1Hcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbZE1Hce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:32:34 -0400
Received: from waldorf.cs.uni-dortmund.de ([129.217.4.42]:44836 "EHLO
	waldorf.cs.uni-dortmund.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbZE1Hce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:32:34 -0400
Date: Thu, 28 May 2009 09:32:34 +0200
From: Christoph Pleger <Christoph.Pleger@cs.tu-dortmund.de>
To: linux-kernel@vger.kernel.org
Subject: Re: chmod fails though it pretends to succeed
Message-Id: <20090528093234.b62bfc08.Christoph.Pleger@cs.tu-dortmund.de>
In-Reply-To: <4A1B2DD6.3050405@gmail.com>
References: <20090525164457.278f0ec0.Christoph.Pleger@cs.tu-dortmund.de>
	<4A1B2DD6.3050405@gmail.com>
Organization: Technische Universitaet Dortmund
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.6.10; sparc-sun-solaris2.10)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 25 May 2009 17:46:30 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> > Now I have two questions:
> > 
> > 1. What can be the reason for chmod to return a value of 0 though
> > device permissions have not been changed?
> > 
> > 2. What can be the reason why this chmod fails on the first login
> > of a user, but succeeds on further logins?
> 
> Are you sure that some other process is not changing the device 
> permissions also?

Maybe, but I do not have an idea what this can be. And if some other
process is interfering, why does this only happen on first login after
boot?

What completely surprises me is that when I install the Debian
lenny package of libpam-devperm (that works perfectly on lenny) on my
Ubuntu jaunty PC, it also does not change device permissions on first
login of a user.

Regards
  Christoph 
