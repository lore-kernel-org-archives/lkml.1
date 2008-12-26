Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYLZWOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYLZWOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 17:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYLZWOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 17:14:07 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:55460 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYLZWOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 17:14:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FrO6hOz5iBEl5DrJIb3PDL8+qxiLClEnCcEjmRGMGMvcWAI8Q0wskLx7+I7zl6wItq
         ZALV6VRdI8vTCqqlpZoXALC6XeBNFAp5XH/zyZXrHrHC7u+DRZHralknnb4Fom456FBN
         d3gud9UWNc+lJS2mKbS0M0UPozefvpPn7g360=
Message-ID: <be9d10f20812261414n30d8061bkf2af90d3cbca8e95@mail.gmail.com>
Date: Sat, 27 Dec 2008 00:14:03 +0200
From: "Don Ash" <donash4@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: qdisc requeue stats
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a way to see q->qstats.requeues statistics
(dev_requeue_skb()) ? I tried tc tool but it does not
show it...


Don.
