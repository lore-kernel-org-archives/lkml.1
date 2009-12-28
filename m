Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZL1Xeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZL1Xeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZL1Xea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:34:30 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:50182 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbZL1Xe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ia4Eg3K8BDVJqIB9gdt610+v4fdoZ9aZ89WgKKgy7Hr+c4zGZD/781eIqRW7oIJUUV
         Wm7OTyv8zbBpdPwZq4Emi4KU/irMLW6w0C7B1cqjM0addsKut8BzXFmbX8MIcjD2+cKl
         7sS541iUdD1Quj+bjEo7ny2x464VXSHx8YfYQ=
MIME-Version: 1.0
Date: Tue, 29 Dec 2009 07:34:29 +0800
Message-ID: <b3657a100912281534y7381a07evd076aabd3371b171@mail.gmail.com>
Subject: [PATCHv4 0/3]posix_acl: Add the acl pointer check
From: liu weni <qingshenlwy@gmail.com>
To: viro <viro@zeniv.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for previous version. I changed the source but forgot patch it again.
And then, I upload this version.
