Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZGMDoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZGMDoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZGMDol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:44:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:1493 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZGMDok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pAnLI1Epvf2b/9xgD9O7+3svF0oYiZwyhpgvL7l+9nv/OLR0XjufVVmaat2BjAKirL
         6nSsNDlP7AaVwf0PAi+flSAxLbZLXIezcHcH3U6HWkZNzubGjueYnyL0B4BFCZNYKZXl
         Jyy+3cKpdNVQWAEApd0fchw60J1bELlkwJQ90=
Date: Sun, 12 Jul 2009 20:44:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nexx <nexx@nexxdesign.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-2.6.30.1 atkbd.c: Add FSC Amilo Pi 3525 Hotkey
	forced releasing
Message-ID: <20090713034436.GC10819@dtor-d630.eng.vmware.com>
References: <4A57CB09.9030404@nexxdesign.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A57CB09.9030404@nexxdesign.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 11, 2009 at 12:13:13AM +0100, Nexx wrote:
> From: Simon Davie <nexx@nexxdesign.co.uk>
> 
> This patch enables forced releasing of the Fn+Volume hotkeys
> on the Fujitsu Siemens Amilo Pi 3525 notebook.
> 
> Signed-off-by: Simon Davie <nexx@nexxdesign.co.uk>

Applied, thank you Simon.

-- 
Dmitry
