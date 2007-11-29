Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbXK2RKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbXK2RKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbXK2RJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:09:55 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:45881 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754345AbXK2RJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iYlDxVqL8niTA/88aCSegnoUs7kWTWkz/iSKqCfouNCHr7atldJ5uEsNgPpG4i6tf8Dm0YLY0O7P5gAYOZIfGP2pHdBAlAcC//5utfeqA3AUP8E5orJEjsaqU9uKegmFzqToZZBEpc3q6kODc+rT5lMqLSOah0vMWldofBs2I7g=
Message-ID: <35fbaa3e0711290909k1965ca75v622f7a36e409d57d@mail.gmail.com>
Date: Thu, 29 Nov 2007 19:09:51 +0200
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Something similar to inotify in 2.4.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Can anyone advice whether there is something similar to inotify in 2.4 kernel?

Need efficient way to track file system changes.

Maybe some other tools, approaches under 2.4?

TIA,
Vitaliy
