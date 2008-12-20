Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbYLTGvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbYLTGvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 01:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYLTGvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 01:51:36 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:42031 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbYLTGvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 01:51:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wKSjbEl61tqPDiVnHU0UIFX2koCi0jD470bEdVFTGFb/fPVTl6jQNr48reQwU++Xzv
         MhYaLwDbnJeZQZmlLDt9PxX9fXjc3YSeRmGzXp7pQG0VOsaD29bR+ufZgoiHJbar8pHT
         6n4pBWSCdJcrevvL95yQdzMxkGHNggfS4LM9U=
Message-ID: <b82a89170812192251u3544f087x94775b6864f5ae8d@mail.gmail.com>
Date: Sat, 20 Dec 2008 12:21:33 +0530
From: "Niraj kumar" <niraj17@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [Question] inotify : process based filtering of events
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I am trying to use inotify to monitor filesystem events but
my problem is that I am only interested in changes that
is being done by a particular process and it's children
(could be the same process which used inotify APIs).

Is it possible to achieve this process based filtering of events
using inotify infrastructure?

-Niraj
