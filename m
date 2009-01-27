Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZA0VXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZA0VXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZA0VXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:23:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:47933 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZA0VXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:23:33 -0500
Date: Tue, 27 Jan 2009 13:23:33 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: dingxn@ymail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: a question about p4_clockmod module on Xeon quad core
 processors
Message-ID: <20090127132333.2e2d4dcf@infradead.org>
In-Reply-To: <603382.20833.qm@web59902.mail.ac4.yahoo.com>
References: <603382.20833.qm@web59902.mail.ac4.yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 12:17:25 -0800 (PST)
Xiaoning Ding <dingxn@ymail.com> wrote:

> Hi list,
> 
> I have tried the p4-clockmod module in Linux kernel 2.6.29 on Xeon
> 5355 quad-core CPUs with no luck. It seems current p4-clockmod driver
> still cannot support Intel Quad core processors, right? 

you know that using clockmod will actually cost you energy rather than
saving it right?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
