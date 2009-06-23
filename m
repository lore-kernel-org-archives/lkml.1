Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbZFWMas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbZFWMas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZFWMaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:30:39 -0400
Received: from mail-yx0-f192.google.com ([209.85.210.192]:64791 "EHLO
	mail-yx0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZFWMai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rHR3fcZ6U4UzTOKJ0hxAM6QdlshcjE3fM/Dg1sMBGXKjcHL93hPqHk6JcTWc8PMMO1
         wYzP7dPq+cEWnjsrhk2QBH0TAvSVQ4KR0tfZcjanLMkh8BGObTPjoh45RtqE4zLvbguw
         u6uSS/WncrYzOV+7Bs2A+VC+YTbZNCclKvbOY=
MIME-Version: 1.0
In-Reply-To: <1244948719-22216-1-git-send-email-vapier@gentoo.org>
References: <20090614012457.GD5986@nowhere> <1244948719-22216-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 23 Jun 2009 08:30:21 -0400
Message-ID: <8bd0f97a0906230530j1cc0efc8i85e9234b2fa0417a@mail.gmail.com>
Subject: Re: [PATCH v4] ftrace: document basic ftracer/ftracer graph needs
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 23:05, Mike Frysinger wrote:
> While implementing ftracer and ftracer graph support, I found the exact
> arch implementation details to be a bit lacking (and my x86 foo ain't
> great).  So after pounding out support for the Blackfin arch, start
> documenting the requirements/details.

Steven: were you going to pick this up ?  or should i forward to Andrew ?
-mike
