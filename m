Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYJOGoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYJOGoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 02:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYJOGoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 02:44:24 -0400
Received: from static.172.68.46.78.clients.your-server.de ([78.46.68.172]:35587
	"EHLO mail.systohc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751211AbYJOGoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 02:44:24 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2008 02:44:23 EDT
Date: Wed, 15 Oct 2008 08:39:17 +0200
From: Fabiano Sidler <lists@fipscode.ch>
To: linux-kernel@vger.kernel.org
Subject: Creating dev nodes from driver or via uevent?
Message-ID: <20081015063917.GA18487@true>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks!

Probably a very basic question, but is it better to directly mknod from a
module's init funtion or to use the uevent/udev mechanism? If the latter,
are there good overviews, explanations and comprehensive code samples
especially for using udev, as well as how to package the userspace program
creating the nodes along with a driver?

Thank you for answering!
Greetings,
Fabiano
