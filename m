Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZKSOZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZKSOZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZKSOZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:25:37 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:60596 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZKSOZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:25:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=NrmdrQnf/1Y15oXQWLBg0eKjskO6HJ/I7uqdFjm+SLjf00UHfQ5i2svce5IHrDKFBV
         rlC2RRAWNZQesT6asST6bn9yKUwgkLJGD/BYwZ1XZmLYj7E2xQKITkaLO3Iwt9B8nd/4
         9/U717GB/PvGKe2w8R/SEYpkBz0Iy8aLmIDPA=
MIME-Version: 1.0
In-Reply-To: <7f9112a50911190603q2bfc7ee2s7639eab5abcad8df@mail.gmail.com>
References: <7f9112a50911190603q2bfc7ee2s7639eab5abcad8df@mail.gmail.com>
Date: Thu, 19 Nov 2009 16:25:40 +0200
Message-ID: <7f9112a50911190625m5d77f067u3a2efccf9479872e@mail.gmail.com>
Subject: is kernel keep connection track?
From: khaled MOHAMMED atteya <khaled.m.atteya@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

if i have multiple ISP connection in my linux gateway , can kernel
keep connection track for each connection?

i mean , suppose i download a file through one isp , i want to
guarantee that , file will be downloaded through this ISP else it will
be stopped

and what about this patch "http://www.ssi.bg/~ja/"?

and if  kernel already keep connection track, which minimal kernel
version do that?




-- 
          ####################
     THERE IS NO GOD BUT ALLAH
MOHAMMED IS MASSENGER OF ALLAH
          ####################
WITH MY RESPECT
Khaled.M.Atteya
