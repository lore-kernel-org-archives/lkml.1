Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbYGTLrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbYGTLrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 07:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYGTLrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 07:47:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:44131 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYGTLrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 07:47:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=P8bSkfGIC7HMnja1oMsVTI9TeSzUaskQxOF+wFP7UMftNOBUR2xw9wi5dQ07j8JmRV
         NeKv4Ie80MizALxmRP8OzIM++ACeEBX9EAoM1phPA5g2mhqcbUT7z0accYGLBSZXVqjU
         +pF8oU5uuinmyflVjmT8++3prpmu2oQ/1Lh4A=
Message-ID: <b6a2187b0807200447s66a4e722r49dd84c69e237a21@mail.gmail.com>
Date: Sun, 20 Jul 2008 19:47:24 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: linux-2.6-26-git can't switch VT after str?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone have any problem switching console VT (even with X) after
suspend-to-ram? It seems the latest git (from a week ago) is having
this symptom, and would like to check if this is already
reported/fixed before I embark on bisecting further. Or perhaps it's
only happening on my X60s.


Thanks,
Jeff.
