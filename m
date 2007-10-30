Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbXJ3Gzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbXJ3Gzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 02:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbXJ3Gzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 02:55:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56846 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbXJ3Gzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 02:55:44 -0400
Date: Tue, 30 Oct 2007 06:55:40 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Cliffe <cliffe@ii.net>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Defense in depth: LSM *modules*, not a static interface
Message-ID: <20071030065540.GH8181@ftp.linux.org.uk>
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl> <4726377A.4080807@crispincowan.com> <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com> <4726D9D9.2000909@ii.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4726D9D9.2000909@ii.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 03:14:33PM +0800, Cliffe wrote:
> Defense in depth has long been recognised as an important secure design 
> principle. Security is best achieved using a layered approach.
 
"Layered approach" is not a magic incantation to excuse any bit of snake
oil.  Homeopathic remedies might not harm (pure water is pure water),
but that's not an excuse for quackery.  And frankly, most of the
"security improvement" crowd sound exactly like woo-peddlers.
