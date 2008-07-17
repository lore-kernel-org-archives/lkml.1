Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbYGQTOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbYGQTOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbYGQTN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:13:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:51091 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760846AbYGQTN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iNTS9OBeeEG/B2rbHD9SVCXgdmgdMZvjI8MkfVd0Twuj9+nW/IvI8B3QQe1hqGyWvg
         GkuUt8GTvM8fdfo+TdrMc3txx/XGahDuF1LfVIRxVy1sHmiU44TxpvnH47uSSgShuAjF
         03lS9l0yUK+j0zIrUIiqR4E7HY/MYxUt/RQwk=
Message-ID: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>
Date: Thu, 17 Jul 2008 21:13:55 +0200
From: "Fred ." <eldmannen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Please add ZFS support (from GPL sources)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we have not been able to have ZFS support due to it being
licensed under the CDDL and the kernel under the GPL.

Sun have contributed ZFS support to GRUB under the GPL license. We
could now use that code to implement support for ZFS in the Linux
kernel.

http://blogs.sun.com/darren/entry/zfs_under_gplv2_already_exists
