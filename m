Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbZD3OuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbZD3OuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZD3Otw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:49:52 -0400
Received: from mailgw2.hevs.ch ([153.109.6.17]:25480 "EHLO mailgw2.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZD3Otw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:49:52 -0400
Message-Id: <49F9D6A5020000BF0002908D@mailgw2.hevs.ch>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 30 Apr 2009 16:49:41 +0200
From: "Marc Pignat" <Marc.Pignat@hevs.ch>
To: <jkosina@suse.cz>
Cc: <linux-bluetooth@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jiri Kosina <jkosina@suse.cz> 04/30/09 3:57 PM >>>
>Does reverting f3784d834c7 fix the problem?

git-revert f3784d834c7 fixed the problem (I can re-use my super-expensive keyboard ;) ).



Best regards

Marc
