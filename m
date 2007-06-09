Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbXFIPBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbXFIPBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 11:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbXFIPB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 11:01:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:28211 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXFIPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 11:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sftNbWWJqwxKnqCF2LPih1bguSEQl6grOluzrsBLyAlE8fNfVrt4Y5+fzUdgyv+2fRjZLJ74E2cG7ElZTDayBkmY97lX+pxHI49hOjoRV+5FoeaMlsV4Tygse+9lDk9IMkLqmfrYtXY2cETJtp6m1L6AMHe6yPwmmzuEEUYFOk8=
Message-ID: <2bd9ebfa0706090801g61e9c7eo67219c300e6bd00d@mail.gmail.com>
Date: Sat, 9 Jun 2007 20:31:27 +0530
From: "Tej Parkash" <tejparkash.d@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: inet_csk_listen_start: function defination
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi all

i am bit confused with the function defination of inet_listen.
How a listen socket can listen and return to application at a time.
since a server stops at accpet not at listen then how listening port start.

I was thinking that the listen call thread out at the tcp_v4_hash
function time but it actaully does not use any thread fucntion and
simple return so how does the listening socket start.

thanks
TEJ
