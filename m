Return-Path: <linux-kernel-owner+w=401wt.eu-S966279AbXDDCL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966279AbXDDCL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966288AbXDDCL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:11:58 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:37524 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966279AbXDDCL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:11:58 -0400
Message-ID: <46130921.7040306@gmail.com>
Date: Wed, 04 Apr 2007 04:10:41 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk> <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com> <4610481D.8000102@gmail.com> <46104954.50608@gmail.com> <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI> <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI> <46111ED7.20201@gmail.com> <Pine.LNX.4.64.0704021837480.6518@sbz-30.cs.Helsinki.FI> <46112650.8080208@gmail.com> <Pine.LNX.4.64.0704021906040.7500@sbz-30.cs.Helsinki.FI> <461165FD.2010508@gmail.com> <Pine.LNX.4.64.0704030908420.20080@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0704030956330.20741@sbz-30.cs.Helsinki.FI> <461256C1.4020906@gmail.com> <Pine.LNX.4.64.0704031723580.3355@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0704032030470.8078@sbz-30.cs.Helsinki.FI> <46129968.9000304@gmail.com> <Pine.LNX.4.64.0704032124591.8078@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0704032124591.8078@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2007 08:32 PM, Pekka J Enberg wrote:

> Please enable CONFIG_DEBUG_SLAB now and reproduce. It should tell us 
> what's going wrong there.

Taking forever to reproduce in as far as getting the oops. The thing is 
now just locking hard each time. Will keep on trying...

Rene.

