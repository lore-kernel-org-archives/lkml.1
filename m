Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYFCAwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYFCAwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 20:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYFCAvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 20:51:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38728 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYFCAvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 20:51:54 -0400
Message-ID: <484495A7.6010006@firstfloor.org>
Date: Tue, 03 Jun 2008 02:51:51 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Rick van Rein <rick@groengemak.nl>
CC: daniel.blueman@gmail.com, david@lang.hm, linux-kernel@vger.kernel.org
Subject: Re: Future Linux on Bistable Storage
References: <20080602125904.GA15129@phantom.vanrein.org> <87prqzvc17.fsf@basil.nowhere.org> <20080602211027.GB18415@phantom.vanrein.org>
In-Reply-To: <20080602211027.GB18415@phantom.vanrein.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick van Rein wrote:

> Thanks for your responses.  You convinced me I/O initiatilisation cannot
> be improved upon.

I'm sure it can. It's just significant work to do it and would need
to be done step by step. It's a bit like the "remove BKL everywhere"
project.

-Andi
