Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbZDQPtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbZDQPtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZDQPtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:49:08 -0400
Received: from japan.chezphil.org ([77.240.5.4]:4866 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685AbZDQPtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:49:08 -0400
X-Greylist: delayed 2615 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Apr 2009 11:49:07 EDT
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Fri, 17 Apr 2009 16:05:26 +0100
Subject: /dev/vcs - poll for changes?
Message-ID: <1239980726652@dmwebmail.dmwebmail.chezphil.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Experts,

Is there a way to detect when the content of a /dev/vcs* has changed?  
I have some code that currently polls, which is obviously sub-optimal.  
I was hoping that there would be some trick like look at the 
modification time, but I haven't found anything.  If this isn't 
currently possible, how easily could it be added?  What would the 
preferred API be, if it were added?

Thanks for any suggestions.

Phil.



