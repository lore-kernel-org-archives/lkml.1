Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYI2NqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYI2NqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYI2Npx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:45:53 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:52377 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYI2Npx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:45:53 -0400
Message-ID: <325d52860809290645p7526b318h7ff9b7e76570f65f@mail.gmail.com>
Date: Mon, 29 Sep 2008 08:45:50 -0500
From: "Jason Czerak" <jason@czerak.com>
To: linux-kernel@vger.kernel.org
Subject: mounted file system bottleneck
In-Reply-To: <325d52860809290641haddf616xfe9c98912352ba22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <325d52860809290641haddf616xfe9c98912352ba22@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe I found some sort of bottleneck with mounted networked file
systems over 10Gig Ethernet.  I've posted a question to linux-net with
zero response since Friday.

http://www.uwsg.indiana.edu/hypermail/linux/net/0809.3/0013.html

Could a few of you folks here take a look at this and tell me what you
think is the issue?




--
Jason Czerak
