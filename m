Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYJMVtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYJMVtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYJMVtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:49:36 -0400
Received: from c60.cesmail.net ([216.154.195.49]:64745 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYJMVtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:49:36 -0400
Subject: Re: [PATCH 25/25] staging: at76_usb wireless driver
From: Pavel Roskin <proski@gnu.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1223933888-8368-2-git-send-email-greg@kroah.com>
References: <20081013213651.GA8338@kroah.com>
	 <1223933888-8368-2-git-send-email-greg@kroah.com>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 17:49:33 -0400
Message-Id: <1223934573.26245.8.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 14:38 -0700, Greg KH wrote:
> From: Pavel Roskin <proski@gnu.org>
> 
> Add the at76_usb wireless driver to the staging tree while the
> other kernel driver (out of tree) gets rewritten to use the internal
> wireless stack.
> 
> This patch comes directly from the Fedora kernel tree, with only the
> directory placement of the files changed.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>

I'm not going to support this code in any way.  I disclaim any
responsibility for this code.

-- 
Regards,
Pavel Roskin
