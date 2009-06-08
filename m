Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbZFHKxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbZFHKxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZFHKxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:53:33 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:38470 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbZFHKxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:53:33 -0400
MIME-Version: 1.0
Date: Mon, 08 Jun 2009 12:52:56 +0200
Reply-To: "harald.dunkel@t-online.de" <harald.dunkel@t-online.de>
To: linux-kernel@vger.kernel.org
X-UMS: email
X-Mailer: TOI Kommunikationscenter V9-3-0-5
Subject: how to stop kernel nfsd?
From: "harald.dunkel@t-online.de" <harald.dunkel@t-online.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <1MDcTI-1elcES0@fwd00.aul.t-online.de>
X-ID: ZYRZlTZDZhUKEg3GkCFn+YlF77XrhuSXO2JGSMeZOJ3j-rJucGkorgMGzMvOokDgP-@t-dialin.net
X-TOI-MSGID: 5a0e6257-8029-4ad0-90b2-926c49f579b1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Which signal would be correct to gracefully kill the kernel nfs daemons?


Debian's runlevel script (just for example) tries SIGINT, but this
doesn't work, as it seems.


Regards

Harri



