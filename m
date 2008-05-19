Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYESIfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYESIfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYESIfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:35:10 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:20899 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYESIfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:35:09 -0400
Message-Id: <483157EE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 19 May 2008 09:35:26 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "linux-kbuild" <linux-kbuild@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] move link of vmlinux from Makefile to a script
References: <482DCD89.76E4.0078.0@novell.com>
 <20080517125204.GA19741@uranus.ravnborg.org>
 <20080518185219.GA777@uranus.ravnborg.org>
 <48314B95.76E4.0078.0@novell.com>
 <20080519081949.GA18279@uranus.ravnborg.org>
In-Reply-To: <20080519081949.GA18279@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Does it fix anything or is it just a clean-up?
>I see it as a cleanup only and thus not -rc material.

It's just an inconvenience it fixes in .25.x (unless you pushed your init.o
exclusion patch to -stable already), and perhaps more a theoretical issue
in .26, but anyway (and irrespective of that for consistency I'd think it
should be done the same way in .25.x and .26).

Jan

