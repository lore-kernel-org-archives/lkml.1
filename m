Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbXCEQ6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbXCEQ6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbXCEQ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:58:43 -0500
Received: from webmail11.yandex.ru ([213.180.200.52]:40770 "EHLO
	webmail11.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbXCEQ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:58:42 -0500
Date: Mon, 5 Mar 2007 19:58:28 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45EC4C34.000001.31254@webmail11.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: timeout = 1 millisecond for wait_event_timeout
X-MsgDayCount: 4
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.214.10
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question. How can I make timeout = 1 millisecond for wait_event_timeout
function? 

Something like (HZ/1000)*x?
