Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYKNW0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYKNW0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYKNWZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:25:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:1251 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbYKNWZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:25:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=XKheRZ1aCR39u1nGeoJGrXyWqtaShrU6uC21ET5DzS0bNbXFCeiftw+Uy0UkkGBax2
         ekzAjdD+0jr/VIlJlLn/rJMelI3twipY9cZQMyV4Fifg+1NmyGkJatb+QU25VMiiA9X7
         LrWjtfkFgofxeMKAK/8dXk415shqVID0hkUr4=
Message-ID: <a4e6962a0811141425n119d624bk8a1a0e3b9c3a9eab@mail.gmail.com>
Date: Fri, 14 Nov 2008 16:25:53 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] bug fixes for 9p linux-2.6.28-rc4
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4ff429e658c00bcf5101eabbebd4f711572a64cb:
  Randy Dunlap (1):
        9p: restrict RDMA usage

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

             -eric
