Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZEDJtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZEDJtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZEDJta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:49:30 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39352 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZEDJta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:49:30 -0400
Date: Mon, 4 May 2009 11:51:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Anders Kaseorg <andersk@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lots of unexpected non-allocatable section warnings
Message-ID: <20090504095119.GB6157@uranus.ravnborg.org>
References: <20090503110517.6d09bca2@hyperion.delvare> <20090503103010.GA27978@uranus.ravnborg.org> <20090503124848.276b437f@hyperion.delvare> <20090503180332.GA31820@uranus.ravnborg.org> <20090503202939.GA1237@uranus.ravnborg.org> <20090504095810.18c1fa6d@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504095810.18c1fa6d@hyperion.delvare>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Yes, it fixes my problem. Thanks for the quick fix! Please push this
> upstream quickly.
Thanks for testing.

I will give it a day or two in -next before I do so.
There seems to be a mips issue too.

	Sam
