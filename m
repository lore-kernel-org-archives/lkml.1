Return-Path: <linux-kernel-owner+w=401wt.eu-S2992624AbXDLQSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992624AbXDLQSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992626AbXDLQSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:18:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:46213 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992624AbXDLQSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kRw5qgPVwzuBAuCsGdDM/vsE0TlGhMORkxVrmzwlcWYiv0XPdk+VBxW6y7ZqOufeFvoTFOFevl/nWXK6395vXG/yCVU5nAJgpgNDT6GPb9OPVKBI8+8Rqg0OB78hIyMBYgHa54X0hwiPlYlskaicj1xNH1nrZWtQtTy090QfKPA=
Message-ID: <3d8471ca0704120918h600180c3xc92cd3a64e205d30@mail.gmail.com>
Date: Thu, 12 Apr 2007 18:18:38 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Christopher S. Aker" <caker@theshore.net>
Subject: Re: [Feature Request?] Inline compression of process core dumps
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <461E55C6.1030905@theshore.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <461E55C6.1030905@theshore.net>
X-Google-Sender-Auth: 2d416506ef08c0ca
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/4/12, Christopher S. Aker <caker@theshore.net>:
> I've been trying to find a method for compressing process core dumps
> before they hit disk.

This seems to be a good use of:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d025c9db7f31fc0554ce7fb2dfc78d35a77f3487

Regards.

-- 
Guillaume
