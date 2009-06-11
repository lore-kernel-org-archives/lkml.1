Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbZFKTlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbZFKTlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZFKTlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:41:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:62513 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbZFKTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=DWi6tS8OQDSsqBX/NhZhE+oS+NtzxpojUp636lJPQgxq4T5tZBtDBsGF+qybrJRrCw
         Mf7xOBktTRd22Nwka+EKs5eZFe2Si5ylhaXyMJyUa3ofBem7tanKN5SWaHqIZm78du5B
         +FuLjOBJPnNgb2otLR7A4RDw25T7jOO7w/sGA=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Jun 2009 12:40:50 -0700
Message-ID: <43e72e890906111240x13ee658av6b89268c3950a2c@mail.gmail.com>
Subject: Stable compat-wireless release for 2.6.30
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.30 is out the respective compat-wireless stable tarball has
been updated based on this release and posted on the project page [1].
If you just want to test the wireless bits of 2.6.30 you can do so
with this release, works on kernels >= 2.6.27. Bugs found here are
very likely bugs on 2.6.30 and should be reported on the
linux-wireless mailing list [2]. For a summary of the wireless bits
that were changed you can refer to our news entry for it [3]. If you
have no luck with that please try our bleeding edge releases based on
wireless-testing [4]. Issues with bleeding edge should also be
reported the linux-wireless mailing list.

[1] http://wireless.kernel.org/en/users/Download/stable
[2] http://wireless.kernel.org/en/developers/MailingLists
[3] http://wireless.kernel.org/News/2009-06-09
[4] http://wireless.kernel.org/en/users/Download

  Luis
