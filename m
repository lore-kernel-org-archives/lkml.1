Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbYC0QUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbYC0QUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbYC0QUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:20:11 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:26144 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046AbYC0QUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Oouzz9VL1Lx8Fzy56wBh6G16lM8KmflkIMyffQTKQw89dWq4j8G6M1upjC1hfDyOuGSuJGfsG35brzxJiaGvBHlmaB09Yd68odPRuIPeHJRktPkntl0O1ZNlGTLM1xdW/wc7Bw/86j8Cl7ZShce8ES3Go/J3noG1c9xjpSOFRfI=
Subject: Re: [RFC PATCH] UBIFS - new flash file system
From: Josh Boyer <jwboyer@gmail.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 11:20:01 -0500
Message-Id: <1206634801.4160.17.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 16:55 +0200, Artem Bityutskiy wrote:
> Dear community,
> 
> here is a new flash file system developed by Nokia engineers with
> help of the University of Szeged. The new file-system is called
> UBIFS, which stands for UBI file system. UBI is the wear-leveling/
> bad-block handling/volume management layer which is already in
> mainline (see drivers/mtd/ubi).

As a suggestion, take everything below this paragraph and above the
diffstat in your original email and throw it in
Documentation/filesystems/ubifs.txt

josh

