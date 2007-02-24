Return-Path: <linux-kernel-owner+w=401wt.eu-S933535AbXBXT2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535AbXBXT2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 14:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933538AbXBXT2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 14:28:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933535AbXBXT2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 14:28:53 -0500
Date: Sat, 24 Feb 2007 11:27:08 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: input.c: start on release
Message-Id: <20070224112708.dd196814.zaitcev@redhat.com>
In-Reply-To: <200702241157.08228.dtor@insightbb.com>
References: <20070222212919.850ceafe.zaitcev@redhat.com>
	<d120d5000702230706u4e7576du6661ce1b58e058aa@mail.gmail.com>
	<20070223164424.0454e11e.zaitcev@redhat.com>
	<200702241157.08228.dtor@insightbb.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007 11:57:07 -0500, Dmitry Torokhov <dtor@insightbb.com> wrote:

> > To tell you the truth, all I really want is to hold a static mutex
> > across a call to input_close_device(). Can I do that?
> 
> Are you trying to fix locking in mousedev?

Yes.

-- Pete
