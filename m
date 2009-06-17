Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZFQX7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZFQX7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZFQX7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:59:17 -0400
Received: from mail-yx0-f198.google.com ([209.85.210.198]:44358 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZFQX7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:59:16 -0400
X-Greylist: delayed 29032 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2009 19:59:16 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HJMl8WEgmV0Si9I2fsaSbkPtAJXnM46JkggiG9Mj/Wv+sjwE6T1KEoiKcosnxF890O
         NNT9ZKoUY6X/g/Y5THvRpnT5dWW5qoRGiucPL9YZ4jIF3se/9YUIqWDGA9BuxF/zqTSW
         J5qELaDZRXm35a/u+2NvVvWmvRFIbppq8pBCs=
MIME-Version: 1.0
In-Reply-To: <20090617195402.GA19771@sequoia.sous-sol.org>
References: <b6a2187b0906170855t5dc7c0c1q48b3c7dca4254594@mail.gmail.com>
	 <20090617195402.GA19771@sequoia.sous-sol.org>
Date: Thu, 18 Jun 2009 07:59:18 +0800
Message-ID: <b6a2187b0906171659k49c9a6edwa94933c72af46eb2@mail.gmail.com>
Subject: Re: 2.6.30 - kernel BUG at lib/kernel_lock.c:126!
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 3:54 AM, Chris Wright<chrisw@sous-sol.org> wrote:
> This fix is queued up in viro's tree already.
> http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commit;h=b0895513f499b8f786d292ce48589ca210ca1d6e

Cool. I see that it's already in the latest git just pulled.

Thanks,
Jeff.
