Return-Path: <linux-kernel-owner+w=401wt.eu-S1763292AbYBFM7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763292AbYBFM7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759871AbYBFM7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:59:41 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:56500 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758071AbYBFM7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:59:40 -0500
X-Authority-Analysis: v=1.0 c=1 a=YzDZ2LFNIjMIFOf7CDQA:9
 a=j9rNRgZFB3F_8EWPR74NOrIHgj0A:4 a=gi0PWCVxevcA:10
Subject: 2.6.24-git15 Keyboard Issue?
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 06 Feb 2008 07:02:58 -0600
Message-Id: <1202302978.9058.13.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I built 2.6.24-git15 this morning and seem to have picked up a little
“funny” along the way – occasionally what should be a single key stroke
ends up spraying multiple characters on to my screen.


By this I mean I type “w” and get “wwwwwwwww” or whatever. 


This has happened a number of times with random keys so I don't think
that it is a sticky key and I did not see this on previous builds.


Has anyone else had this happen to them?  While they were sober that
is.    


