Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbYATHa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbYATHa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 02:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYATHaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 02:30:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:43300 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753917AbYATHaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 02:30:17 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19cTnALUgNcCmplT5W/DgbfUFBbs+f08iwBHgXWep
	8A5huw5Op+3A7k
Subject: Re: konqueror deadlocks on 2.6.22
From: Mike Galbraith <efault@gmx.de>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200801200831.04964.a1426z@gawab.com>
References: <200801192114.41427.a1426z@gawab.com>
	 <1200802290.4166.2.camel@homer.simson.net>
	 <200801200831.04964.a1426z@gawab.com>
Content-Type: text/plain
Date: Sun, 20 Jan 2008 08:30:14 +0100
Message-Id: <1200814214.5236.16.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-20 at 08:41 +0300, Al Boldi wrote:

> logic.  Any ideas how this could be fixed?

BTW, no idea, fs is taboo land here. (panic() is my very favorite
function...;)

	-Mike

