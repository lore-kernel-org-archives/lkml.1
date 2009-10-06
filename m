Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbZJFVHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbZJFVHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933186AbZJFVHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:07:23 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:54443 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053AbZJFVHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:07:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=qu6CCT1y/LdxNb57TwEHYZ6ZzesclR76LvsydZczQXbMVRgFyDliWQ/CAkRhTXYZ0k
         CpWVD+hDhGgjQ+eZr3nZjW0y7vQ2ybK1QIL7BJZ1nT5QmHVEdL0CIRlb7/RWzVyIOpsj
         9Wb6HrrDumqq3HY7Gh2SrISMacwi1xNjYdg7g=
MIME-Version: 1.0
Date: Tue, 6 Oct 2009 23:06:45 +0200
Message-ID: <63386a3d0910061406p32e514cdjbe6059e7af60fb87@mail.gmail.com>
Subject: CGFreak control group visualizer
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while back I started to write CGFreak to visualize the intricacies of control
groups using some python and cairo. (Nothing special, just a hobby - famous
last words.) I have a web page of it running with some explanations of what
you see here:

  http://cgfreak.sourceforge.net/

The basic idea is that resources can often be represented in piecharts,
everyone should be familiar with these from school and economists love
them. So I visualize system resources in control groups as piecharts and
now I have also started to make it a bit interactive. It all grew out of the
educational need to understand scheduling and control groups.

I don't know if you think this is as fun as I think, it's nice images anyway,
I don't know how accurate they are, feedback and patches welcome.

Linus Walleij
