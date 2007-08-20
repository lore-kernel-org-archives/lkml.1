Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbXHTA50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbXHTA50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbXHTA5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:57:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:20034 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbXHTA5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mdxyn8eddS5rOhYohjdxdSdPertqyoCp7qkcSzYbxQIwRDzFq4+ELpA/SotYFUdTxyetF9011TldbJFslwS+nU3l9lIgO0p/zMY+Ev84XT8e+pa/3p3xBmRmsYe6/eBoiGwHpbHBrFrgOW2puVqKflvedjGU5Xi6Zbdi9pHq7Ls=
Message-ID: <82ab508a0708191757q5da6ac96g8f8992c6123ab557@mail.gmail.com>
Date: Mon, 20 Aug 2007 09:57:10 +0900
From: "jungseung lee" <lkml.js@gmail.com>
To: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: gitstat 0.1: kernel development statistics / monitoring system
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the release of gitstat 0.1.

Gitstat is a GPL'd, web-based git statistics/monitoring system.

It retrieves a specified git tree, analyzes changesets,
and shows graphical information like the number of changesets per day, the
number of people who submitted changesets for a specific version(tag)…etc.

Users may subscribe to gitstat so that they automatically receive
an email notification if any change is applied to a specified
directory. Currently, gitstat is mainly for linux kernel developers
to monitor kernel development more conveniently with email notifications.

It also shows each changset that users can search
through with a specified title, content or developer.

Gitstat was originally developed for internal use with minimal functionalities
and therefore has much room for improvement. We hope more people
join us to make this system a better one.

gitstat was derived from kfm(kernel feature monitor) which
was originally developed by Keun-Sik Lim and Sang-Bae Lee of
Samsung Electronics and currently maintained and developed by
Jeong-Seung Lee and Soon-Son Kwon(Shawn) of Samsung Electronics.

kfm was inspired from Jon Corbet of lwn.net when he analyzed the
git tree and Greg KH when he presented similar status report at OLS2007.
We thought it would be interesting those information every day.

You are welcome to try gitstat at http://tree.celinuxforum.org/gitstat

For any suggestion, bug report, or patches, please visit
http://sourceforge.net/projects/gitstat

The developers would like to thank Samsung for sponsoring the
work and CE Linux Forum for providing the hosting space
