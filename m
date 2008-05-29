Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYE2P3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYE2P3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbYE2P3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:29:47 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:53076 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYE2P3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YHlvUJ3erwmgiMJqR4PkyRIpA8QBvh9M8HBegvVCjpU3pvkj/MRA2vdNeYRkGLSsO/wOSj2ThDbXhLubFWDBDclgQVXnMWKsWObJzTwOflfvZfh/uFs/dd4fAZBmStF5V/RMX54fYhC6gSwT5lpwxWGY7vGkWZsix+plFhtmyJc=
Message-ID: <fb7befa20805290829n5bf70832wc8c4129a8433d802@mail.gmail.com>
Date: Thu, 29 May 2008 11:29:44 -0400
From: "Adayadil Thomas" <adayadil.thomas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question regarding TCP behavior
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.

I have a question about how linux's TCP stack behaves.
I apologize if this is not the right place to ask this question and
please redirect me.

When a TCP end point (A) sends x bytes of data to the other end point (B),
does B immediately ACK the received bytes or will it do so only when the data
is passed to the upper layer ?


Thanks
Thomas
