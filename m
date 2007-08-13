Return-Path: <linux-kernel-owner+w=401wt.eu-S947831AbXHMPBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947831AbXHMPBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969825AbXHMMgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:36:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:8332 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969273AbXHMMgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=NOlFR8pMDm/AKIou9HY3So9xmdZ4pELUCMaeWJlA5WyBoCOlx7tskIVWjNhG84f+0QCcxp4WI+62ukYUkkp9ju0EWrZjFFeAkCCJRgSmMWpOv9K4+f6jpFKVHmw+3mkZUqyQVYJdeIgTOGMkhNhxmmkAKxMBxxy4I/Eb3PSrHtw=
Date: Mon, 13 Aug 2007 20:35:55 +0800
From: lepton <ytht.net@gmail.com>
To: lkm <linux-kernel@vger.kernel.org>
Cc: bcollins@debian.org
Subject: I have two 1394 port in my computer, why did I get only one eth1394 interface?
Message-ID: <20070813123555.GA6276@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   My computer has two 1394 port, one is in the front panel, and another
is in the back. I found with linux 1394 ethernet support, I only get one
ethernet device named eth1.
   After read code, I found author says "This is where we add all of
our ethernet * devices. One for each host."
   Then my question is:
   1. Is it possible to use every 1394 port as a ethernet device?
   2. If not, which port should I plug my firewire line into?
   3. If I must plug my firewire line in some port, can I change the
default port to use?
   Thanks.
