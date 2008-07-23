Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYGWRua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYGWRua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYGWRuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:50:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:54862 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYGWRuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:50:22 -0400
Subject: Re: Odd swapping issue
From: Peter Zijlstra <peterz@infradead.org>
To: Rafal Wijata <devnull@wijata.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <488761F0.4040906@wijata.com>
References: <488761F0.4040906@wijata.com>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 19:50:28 +0200
Message-Id: <1216835428.7257.194.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-23 at 18:53 +0200, Rafal Wijata wrote:
> It happened twice recently(within one week), therefore I'm posting here.
> 
> 32bit Fedora7, 2.6.23.17-88.fc7PAE, 16G ram, 12G swap, 2*dualXeon

16g ram on a 32bit kernel is stretching it... may I suggest running a
64bit kernel?


