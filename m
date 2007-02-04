Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbXBDMKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbXBDMKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 07:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXBDMKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 07:10:37 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:37062 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbXBDMKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 07:10:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Bf9jHD1qmnq5s0QjIreN/HnuMwFk1FZkItIQ14XG0sOOFTSPPOzJTTJbIeGcKIEsh57gzKGqi0IqNvWwuw6OzIgFHZArTHaS3gVZJ/kp67qGWJLr2uWFkAmIkeGZo80MyDpVkEeLp8ecgCUpmsufGEW/9XDuT+fovoy9y5QY3Z8=
Date: Sun, 4 Feb 2007 14:10:25 +0200
To: linux-kernel@vger.kernel.org
Subject: Re: A CodingStyle suggestion
Message-ID: <20070204121025.GA9785@Ahmed>
References: <20070203215848.GA10440@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070203215848.GA10440@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 11:58:48PM +0200, Darwish wrote:
> Hi all,
> 
> In CodingStyle Chapter 16 "Function return value and names", why not
> adding a comment about the favorable community way of checking the return
> value. ie:
> 
> ret = do_method();
> if (ret) {
>    /* deal with error */
> }

Thanks for all the replies, A patch will be sent in a new thread.  

Regards
-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
