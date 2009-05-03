Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbZECOzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbZECOzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 10:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZECOzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 10:55:41 -0400
Received: from mailgw2.hevs.ch ([153.109.6.17]:33660 "EHLO mailgw2.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbZECOzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 10:55:40 -0400
Message-Id: <49FDCC85020000BF000290ED@mailgw2.hevs.ch>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Sun, 03 May 2009 16:55:33 +0200
From: "Marc Pignat" <Marc.Pignat@hevs.ch>
To: <justinmattock@gmail.com>, <marcel@holtmann.org>
Cc: <hidave.darkstar@gmail.com>, <ext-roger.quadros@nokia.com>,
       <jkosina@suse.cz>, <linux-bluetooth@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Marcel Holtmann <marcel@holtmann.org> 05/02/09 11:15 PM >>>
...
> thanks for testing.

> Marc, Roger, can you test this and confirm that it works for you and
> doesn't have any other side effects. Then I prepare it work upstream
> inclusion.

Tested and working!

Exercise left for 2.6.31: use the system wide wq ;)

Best regards

Marc
